# TF2 Classified Custom Schema Download

A small SourceMod plugin that makes a server's global Team Fortress 2 Classified custom weapon schema download to connecting clients.

TF2 Classified can load `scripts/items/custom_items_game.txt` from a server-side VPK or loose installation, but loading the schema on the server does not automatically guarantee that clients receive it. Without the matching client schema, custom weapons may function server-side while remaining absent from the Armory and loadout screens.

This plugin adds the schema to Source's download table on every map start:

```text
scripts/items/custom_items_game.txt
```

It is map-agnostic. Custom weapons work on stock or custom maps without renaming, modifying, or packing each BSP.

## Requirements

- Team Fortress 2 Classified dedicated server
- MetaMod:Source
- SourceMod
- A working FastDL server
- A Classified-compatible `custom_items_game.txt`
- The custom weapon pack's client assets

## Complete setup

### 1. Install the weapon pack on the game server

Mount the weapon pack VPK beneath the server's game directory:

```text
tf2classified/custom/your_weapon_pack.vpk
```

The pack should contain its global schema at:

```text
scripts/items/custom_items_game.txt
```

Current Classified schemas should normally begin with:

```text
#base "items_game.txt"
```

Only one custom item schema can be active at a time. Disable other packs containing `custom_items_game.txt` while testing.

### 2. Keep a loose server-side schema

Place the same schema at:

```text
tf2classified/scripts/items/custom_items_game.txt
```

The plugin verifies this path before advertising it. The loose file must exactly match the schema in the mounted pack.

### 3. Install the SourceMod plugin

Download `tf2c_custom_schema_download.smx` from the latest release and place it at:

```text
tf2classified/addons/sourcemod/plugins/tf2c_custom_schema_download.smx
```

Change map or restart the server. Verify it with:

```text
sm plugins info tf2c_custom_schema_download
sm_tf2c_custom_schema_download_version
tf2c_custom_item_schema
```

The plugin log should contain:

```text
Added scripts/items/custom_items_game.txt to the client download table
```

### 4. Prepare FastDL

Extract the weapon VPK into the directory served beneath your `sv_downloadurl`, preserving every relative path. Do not place only the VPK on FastDL.

For a URL configured like this:

```text
sv_downloadurl "https://example.com/tf2classified/"
```

the schema must be available as either the raw file or a Source-compatible bzip2 file:

```text
https://example.com/tf2classified/scripts/items/custom_items_game.txt
https://example.com/tf2classified/scripts/items/custom_items_game.txt.bz2
```

Publish all client-facing content from the pack, including:

- `scripts/items/custom_items_game.txt`
- `models/**`
- `materials/**`
- `sound/**`
- `particles/**`, when used
- `resource/**`, when used for icons or localization

Do not publish `scripts/vscripts/**` to clients. Keep VScript in the server-mounted VPK. Current Classified security rules do not load client-side VScripts received from servers or maps.

FastDL paths are case-sensitive on most web hosts. Their capitalization must match the paths referenced by the schema and assets.

### 5. Enable downloads

The server configuration needs downloads enabled and a valid FastDL root:

```text
sv_allowdownload 1
sv_downloadurl "https://example.com/tf2classified/"
```

Players must not have disabled downloads with `cl_allowdownload 0` or `cl_downloadfilter none`.

### 6. Test with a clean client

Remove or disable the weapon VPK from the test client's `custom` directory, then connect after a server map change.

The downloaded schema should appear at:

```text
tf2classified/download/scripts/items/custom_items_game.txt
```

Confirm that:

1. The custom weapons appear in the Armory and loadout screens.
2. They can be equipped on a stock map.
3. View models, world models, materials, sounds, icons, and effects load correctly.
4. The setup survives reconnects and map changes.

## Why common attempts fail

### The schema works on the server but not in the Armory

The server mounted the schema, but the client did not receive it. Install this plugin and verify the FastDL schema URL.

### Adding the VPK to the download table

A VPK downloaded during connection is not reliably mounted into the client's search path for that connection. Advertise the loose schema and serve the VPK's unpacked client files instead.

### Editing `downloads.ini`

That file is read only by downloader plugins specifically designed for it. Starbish's `S_Downloader` does not use `downloads.ini`; it scans loose resource directories and does not reliably discover resources contained only inside a VPK. This plugin registers the schema explicitly.

### Packing or renaming every map

Current TF2 Classified uses one global custom schema. The active map does not need a schema sidecar or modified BSP.

### FastDL returns 404 for the raw file

Hosting only `.bz2` is valid when Source successfully requests that variant. Test the exact `.bz2` URL and verify that decompression produces the original file.

## Building

Run the included PowerShell build script with the path to an installed SourceMod tree:

```powershell
.\build.ps1 -SourceModPath "C:\path\to\tf2classified\addons\sourcemod"
```

The compiled plugin is written to `build/tf2c_custom_schema_download.smx`.

## References

- [TF2 Classified 3.0.11 hosting instructions](https://store.steampowered.com/news/posts/?enddate=1782179470&feed=steam_community_announcements)
- [TF2 Classified custom weapon basics](https://wiki.tf2classified.com/wiki/Creating_custom_weapons_-_basics)

## License

MIT
