## Command line arguments

When running the game from the command line, you can add the following options to make testing faster:
- `--puzzle=XXX` will automatically enter puzzle XXX.
- `--user=YYY` will automatically log in with user YYY.
- `--no-splash` or `--skip-splash` will skip the splash screen.
- `--steam` will integrate Steam API with MarvInc, however you'll need to place these two DLL files in your love.exe folder:
    - [steam_api.dll](https://drive.google.com/uc?export=download&id=0B-V5MASkccPiOUVUR0hobW91MTg)
    - [steam_api64.dll](https://drive.google.com/uc?export=download&id=0B-V5MASkccPiSkxleko2b3hwRmM)
- `--steamdev` will integrate Steam API with MarvInc in dev mode, creating an auxiliary appID file. You'll still need the DLLs.
