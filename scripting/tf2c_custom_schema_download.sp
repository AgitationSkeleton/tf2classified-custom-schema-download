#include <sourcemod>
#include <sdktools_stringtables>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.0.1"
#define SCHEMA_PATH "scripts/items/custom_items_game.txt"

public Plugin myinfo =
{
    name = "TF2C Custom Schema Download",
    author = "Vio's Arcade",
    description = "Adds TF2 Classified's global custom item schema to the client download table.",
    version = PLUGIN_VERSION,
    url = "https://github.com/AgitationSkeleton/tf2classified-custom-schema-download"
};

public void OnPluginStart()
{
    CreateConVar(
        "sm_tf2c_custom_schema_download_version",
        PLUGIN_VERSION,
        "TF2C custom schema download plugin version.",
        FCVAR_NOTIFY | FCVAR_DONTRECORD
    );
}

public void OnMapStart()
{
    if (!FileExists(SCHEMA_PATH, true))
    {
        LogError("Custom item schema is missing: %s", SCHEMA_PATH);
        return;
    }

    AddFileToDownloadsTable(SCHEMA_PATH);
    LogMessage("Added %s to the client download table", SCHEMA_PATH);
}
