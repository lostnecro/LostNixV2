{ config, pkgs, inputs, ... }:

{
  
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    nixpkgs.pkgs = pkgs;

    colorschemes.tokyonight = {
    enable = true;
    settings.transparent = true;
    };
    # Modular plugins
    plugins.lualine.enable = true;
    plugins.dropbar.enable = true;
    plugins.bufferline.enable = true;
    plugins.web-devicons.enable = true;
    plugins.illuminate.enable = true;
    plugins.dashboard.enable = true;
    plugins.toggleterm.enable = true;
    plugins.telescope.enable = true;
    plugins.chadtree.enable = true;
    plugins.yazi.enable = true;
    plugins.which-key.enable = true;
    plugins.vimwiki.enable = true;
    plugins.avante.enable = true;
  
    # Autocomplete
    plugins.blink-cmp.enable = true;
    plugins.blink-cmp-git.enable = true;


    # Options
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      termguicolors = true;
      mouse = "a";
      clipboard = "unnamedplus";
    };

    extraConfigLua = ''
      require("antigravity").setup({
        cmd = "agy",
        style = "split", -- use "float" for floating terminal, or "vsplit" / "split"
        width_ratio = 0.8,
        height_ratio = 0.8,
        border = "rounded",
      })
    '';


    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>CHADopen<cr>";
      }
      {
        mode = "n";
        key = "<leader>[";
        action = "<cmd>BufferLineCyclePrev<cr>";
      }
      {
        mode = "n";
        key = "<leader>]";
        action = "<cmd>BufferLineCycleNext<cr>";
      }
      {
        mode = "n";
        key = "<leader>y";
        action = "<cmd>Yazi<cr>";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<cr>";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>BufferLinePickClose<cr>";
      }
    ];
  };
}