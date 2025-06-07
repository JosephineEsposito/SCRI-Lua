#include <pacman_include.hpp>
#include <lua.hpp>
#include <lualib.h>
#include <lauxlib.h>

int num_coins = 0;
const int platas_para_oro = 5;
const int bronces_para_plata = 100;

const float max_vida = 1.5f;
float vida = max_vida;

lua_State* L = nullptr;


bool reloadLuaScript() {
	if (L) {
		lua_close(L);
		L = nullptr;
	}

	L = luaL_newstate();
	if (L == nullptr) {
		fprintf(stderr, "Error: impossible creating a new state Lua for the reload.\n");
		return false;
	}

	luaL_openlibs(L);

	if (luaL_loadfile(L, "pacman.lua") || lua_pcall(L, 0, 0, 0)) {
		fprintf(stderr, "Error with the loading or execution of pacman.lua during the reload: %s\n", lua_tostring(L, -1));
		lua_close(L);
		L = nullptr;
		return false;
	}

	fprintf(stdout, "Script pacman.lua reloaded!\n");
	return true;
}


bool pacmanEatenCallback(int& score, bool& muerto)
{ // Pacman ha sido comido por un fantasma
	vida -= 0.5f;
	muerto = vida < 0.0f;

	return true;
}

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
{ // Pacman se ha comido un powerUp
	setPacmanSpeedMultiplier(2.0f);
	setPowerUpTime(5);

	score += 5000;
	
	// obtaining the current lives
	float currentLives = 0.0f;
	getLives(currentLives);

	if (L)
	{
		lua_getglobal(L, "getPacmanPowerUpColor");
		lua_pushnumber(L, currentLives);

		if (lua_pcall(L, 1, 1, 0) != 0)
		{
			fprintf(stderr, "Error in calling getPacmanPowerUpColor: %s\n", lua_tostring(L, -1));
			setPacmanColor(200, 200, 200);
			return true;

			// Recupera il valore di ritorno (una tabella) dallo stack
			if (lua_istable(L, -1))
			{
				int r, g, b;

				lua_pushstring(L, "r");
				lua_gettable(L, -2);
				r = static_cast<int>(lua_tonumber(L, -1));
				lua_pop(L, 1);

				lua_pushstring(L, "g");
				lua_gettable(L, -2);
				g = static_cast<int>(lua_tonumber(L, -1));
				lua_pop(L, 1);

				lua_pushstring(L, "b");
				lua_gettable(L, -2);
				b = static_cast<int>(lua_tonumber(L, -1));
				lua_pop(L, 1);

				lua_pop(L, 1);

				setPacmanColor(r, g, b);
			}
			else
			{
				fprintf(stderr, "getPacmanPowerUpColor non ha restituito una tabella valida.\n");
				setPacmanColor(255, 0, 0); // Colore di default in caso di tipo di ritorno errato
				lua_pop(L, 1); // Rimuovi il valore non tabella dallo stack
			}
		}
		else
		{
			// Se lo stato Lua non è inizializzato, imposta un colore di default
			setPacmanColor(255, 0, 0);
		}
		return true;
	}
}

bool powerUpGone()
{ // El powerUp se ha acabado
	setPacmanColor(255, 0, 0);
	setPacmanSpeedMultiplier(1.0f);
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

bool setImmuneCallback()
{
    return true;
}

bool removeImmuneCallback()
{
    return true;
}

bool InitGame()
{
	return reloadLuaScript();
}

bool EndGame()
{
	if (L)
	{
		lua_close(L);
		L = nullptr;
	}
  return true;
}

//EOF