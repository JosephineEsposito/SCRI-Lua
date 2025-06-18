#include <pacman_include.hpp>
#include <lua.hpp>
#include <lualib.h>
#include <lauxlib.h>


int num_coins = 0;
const int platas_para_oro = 5;
const int bronces_para_plata = 100;

const float max_vida = 1.5f;
float vida = max_vida;


#pragma region | Pacman class
class Pacman
{
public:
	Pacman() { fprintf(stdout, "Pacman instance created (C++)\n"); }
	~Pacman() { fprintf(stdout, "Pacman instance destroyed (C++)\n"); }

	void setSpeedMultiplier(float multiplier) { setPacmanSpeedMultiplier(multiplier); }
	void setColor(int r, int g, int b) { setPacmanColor(r, g, b); }
	void setPowerUpDuration(int seconds) { setPowerUpTime(seconds); }
	
	float getLivesValue()
	{
		float vidas = 0.0f;
		getLives(vidas);
		return vidas;
	}
};

Pacman* g_pacmanInstance = nullptr;
#pragma endregion


lua_State* L = nullptr;



#pragma region | lua
Pacman* checkPacman(lua_State* L, int args)
{
	void* userdata = luaL_checkudata(L, args, "PacmanMetatalbe");
	luaL_argcheck(L, userdata != NULL, args, "`Pacman` expected");
	return *static_cast<Pacman**>(userdata);
}

int lua_Pacman_setSpeedMultiplier(lua_State* L)
{
	Pacman* pacman = checkPacman(L, 1);
	float multiplier = static_cast<float>(luaL_checknumber(L, 2));

	pacman->setSpeedMultiplier(multiplier);
	return 0;
}

int lua_Pacman_setColor(lua_State* L)
{
	Pacman* pacman = checkPacman(L, 1);
	int r = static_cast<int>(luaL_checknumber(L, 2));
	int g = static_cast<int>(luaL_checknumber(L, 3));
	int b = static_cast<int>(luaL_checknumber(L, 4));

	pacman->setColor(r, g, b);
	return 0;
}

int lua_Pacman_setPowerUpDuration(lua_State* L)
{
	Pacman* pacman = checkPacman(L, 1);
	int seconds = static_cast<int>(luaL_checknumber(L, 2));

	pacman->setPowerUpDuration(seconds);
	return 0;
}

int lua_Pacman_getLivesValue(lua_State* L)
{
	Pacman* pacman = checkPacman(L, 1);
	float lives = pacman->getLivesValue();
	lua_pushnumber(L, lives);
	return 1;
}

int lua_createPacman(lua_State* L)
{
	Pacman** ppacman = static_cast<Pacman**>(lua_newuserdata(L, sizeof(Pacman*)));
	*ppacman = g_pacmanInstance;

	luaL_getmetatable(L, "PacmanMetatable");
	lua_setmetatable(L, -2);

	return 1;
}

int lua_Pacman_gc(lua_State* L)
{
	fprintf(stdout, "Pacman userdata being garbage collected.\n");
	return 0;
}

const struct luaL_Reg pacman_methods[] = {
		{"setSpeedMultiplier", lua_Pacman_setSpeedMultiplier},
		{"setColor", lua_Pacman_setColor},
		{"setPowerUpDuration", lua_Pacman_setPowerUpDuration},
		{"getLivesValue", lua_Pacman_getLivesValue},
		{"__gc", lua_Pacman_gc},
		{NULL, NULL}
};

int lua_setPacmanSpeedMultiplier(lua_State* L)
{
	int nArgs = lua_gettop(L);
	if (nArgs != 1 || !lua_isnumber(L, 1))
	{
		luaL_error(L, "Error: setPacmanSpeedMultiplier needs a numeric argument (multiplier).");
		return 0;
	}

	float multiplier = static_cast<float>(lua_tonumber(L, 1));

	setPacmanSpeedMultiplier(multiplier);

	return 0;
}

int lua_setPacmanColor(lua_State* L)
{
	int nArgs = lua_gettop(L);
	if (nArgs != 3 || !lua_isnumber(L, 1) || !lua_isnumber(L, 2) || !lua_isnumber(L, 3))
	{
		luaL_error(L, "lua_setPacmanColor: requires 3 numeric arguments (r, g, b)");
		return 0;
	}

	int r = static_cast<int>(lua_tonumber(L, 1));
	int g = static_cast<int>(lua_tonumber(L, 2));
	int b = static_cast<int>(lua_tonumber(L, 3));

	setPacmanColor(r, g, b);

	return 0;
}

int lua_setPowerUpTime(lua_State* L)
{
	int nArgs = lua_gettop(L);
	if (nArgs != 1 || !lua_isnumber(L, 1))
	{
		luaL_error(L, "lua_setPowerUpTime: requires a numeric argument (seconds)");
		return 0;
	}

	int seconds = static_cast<int>(lua_tonumber(L, 1));

	setPowerUpTime(seconds);

	return 0;
}

int lua_getLives(lua_State* L)
{
	int nArgs = lua_gettop(L);
	if (nArgs != 0)
	{
		luaL_error(L, "lua_getLives: does not require arguments");
		return 0;
	}

	float currentLives = 0.0f;
	getLives(currentLives);

	lua_pushnumber(L, currentLives);

	return 1;
}

#pragma endregion


bool reloadLuaScript()
{
	if (L)
	{
		lua_close(L);
		L = nullptr;
	}

	L = luaL_newstate();
	if (L == nullptr)
	{
		fprintf(stderr, "Error: impossible to create a new state Lua for reload.\n");
		return false;
	}

	luaL_openlibs(L);

	luaL_newmetatable(L, "PacmanMetatable");
	lua_pushvalue(L, -1);
	lua_setfield(L, -2, "__index");
	luaL_Reg const* l;
	for (l = pacman_methods; l->name; l++) {
		lua_pushcfunction(L, l->func);
		lua_setfield(L, -2, l->name);
	}

	lua_register(L, "Pacman", lua_createPacman);

	if (g_pacmanInstance == nullptr)
	{
		g_pacmanInstance = new Pacman();
	}

	if (luaL_loadfile(L, "pacman.lua") || lua_pcall(L, 0, 0, 0)) {
		fprintf(stderr, "Error with loading: %s\n", lua_tostring(L, -1));
		lua_close(L);
		L = nullptr;
		return false;
	}

	fprintf(stdout, "Script pacman.lua loaded.\n");
	return true;
}


#pragma region | Callbacks

bool coinEatenCallback(int& score)
{ // Pacman se ha comido una moneda
	++num_coins;
	score = num_coins * 50;

	return true;
}

bool frameCallback(float time)
{ // Se llama periodicamente cada frame
	reloadLuaScript();
	return false;
}

bool ghostEatenCallback(int& score)
{ // Pacman se ha comido un fantasma
	return false;
}

bool powerUpEatenCallback(int& score)
{
	if (L && g_pacmanInstance)
	{
		lua_getglobal(L, "myPacman");
		if (!lua_isuserdata(L, -1))
		{
			fprintf(stderr, "Error: myPacman not a userdata Pacman in Lua.\n");
			lua_pop(L, 1);
			// Fallback
			setPacmanSpeedMultiplier(2.0f);
			setPacmanColor(0, 255, 0);
			setPowerUpTime(5);
			return true;
		}

		lua_getfield(L, -1, "onPowerUpEaten");
		if (!lua_isfunction(L, -1)) {
			fprintf(stderr, "Error: method onPowerUpEaten not found.\n");
			lua_pop(L, 2);
			// Fallback
			setPacmanSpeedMultiplier(2.0f);
			setPacmanColor(0, 255, 0);
			setPowerUpTime(5);
			return true;
		}

		lua_pushvalue(L, -2);
		lua_pushnumber(L, score);

		if (lua_pcall(L, 2, 1, 0) != 0)
		{
			fprintf(stderr, "Error with myPacman:onPowerUpEaten in Lua: %s\n", lua_tostring(L, -1));
			lua_pop(L, 1);
		}
		else
		{
			score = static_cast<int>(lua_tonumber(L, -1));
			lua_pop(L, 1);
		}
		lua_pop(L, 1);
	}
	else
	{
		setPacmanSpeedMultiplier(2.0f);
		setPacmanColor(0, 255, 0);
		setPowerUpTime(5);
	}
	return true;
}

bool setImmuneCallback()
{
	return true;
}

bool removeImmuneCallback()
{
	return true;
}

#pragma endregion

bool pacmanEatenCallback(int& score, bool& muerto)
{ // Pacman ha sido comido por un fantasma
	vida -= 0.5f;
	muerto = vida < 0.0f;

	return true;
}

bool powerUpGone()
{
	if (L && g_pacmanInstance)
	{
		lua_getglobal(L, "myPacman");
		if (!lua_isuserdata(L, -1))
		{
			fprintf(stderr, "Error: myPacman not a userdata Pacman in Lua for powerUpGone.\n");
			lua_pop(L, 1);
			setPacmanColor(255, 0, 0);
			setPacmanSpeedMultiplier(1.0f);
			return true;
		}

		lua_getfield(L, -1, "onPowerUpGone");
		if (!lua_isfunction(L, -1))
		{
			fprintf(stderr, "Error: onPowerUpGone not found.\n");
			lua_pop(L, 2);
			setPacmanColor(255, 0, 0);
			setPacmanSpeedMultiplier(1.0f);
			return true;
		}

		lua_pushvalue(L, -2);
		if (lua_pcall(L, 1, 0, 0) != 0)
		{
			fprintf(stderr, "Error in myPacman:onPowerUpGone in Lua: %s\n", lua_tostring(L, -1));
			lua_pop(L, 1);
		}
		lua_pop(L, 1);
	}
	else
	{
		setPacmanColor(255, 0, 0);
		setPacmanSpeedMultiplier(1.0f);
	}
	return true;
}

bool pacmanRestarted(int& score)
{
	score = 0;
	num_coins = 0;
	vida = max_vida;

	return true;
}

bool computeMedals(int& oro, int& plata, int& bronce, int score)
{
	plata = score / bronces_para_plata;
	bronce = score % bronces_para_plata;
	
	oro = plata / platas_para_oro;
	plata = plata % platas_para_oro;

	return true;
}

bool getLives(float& vidas)
{
	vidas = vida;
	return true;
}



bool InitGame()
{
	if (g_pacmanInstance == nullptr)
	{
		g_pacmanInstance = new Pacman();
	}
	return reloadLuaScript();
}

bool EndGame()
{
	if (L)
	{
		lua_close(L);
		L = nullptr;
	}
	if (g_pacmanInstance)
	{
		delete g_pacmanInstance;
		g_pacmanInstance = nullptr;
	}
	return true;
}


//EOF