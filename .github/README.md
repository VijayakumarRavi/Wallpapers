# Wallpapers

A collection of wallpapers and a script to set them easily.

## Usage

This project is set up as a Nix flake. To use it, follow these steps:

1. Make sure you have Nix installed with flakes enabled.

2. To run the wallpaper selection script:

   ```
   nix run github:VijayakumarRavi/Wallpapers
   ```

   This will launch the interactive wallpaper selection tool.

3. If you want to use a specific directory for wallpapers, you can pass it as an argument:

   ```
   nix run github:VijayakumarRavi/Wallpapers -- /path/to/your/wallpapers
   ```

4. To add this flake as an input to your own flake:

   ```nix
   {
     inputs.wallpapers.url = "github:VijayakumarRavi/Wallpapers";

     # Then in your outputs:
     outputs = { self, nixpkgs, wallpapers }: {
       # Use wallpapers as needed
     };
   }
   ```

5. You can also use the wallpaper script in your NixOS configuration:

   ```nix
   {
     environment.systemPackages = [
       wallpapers.packages.${system}.chwallpaper
     ];
   }
   ```

   This will make the `chwallpaper` command available in your system.

Enjoy setting your new wallpapers!

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to add new wallpapers to this collection.

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
