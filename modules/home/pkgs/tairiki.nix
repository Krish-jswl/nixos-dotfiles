{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "tairiki.nvim";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "deparr";
    repo = "tairiki.nvim";
    rev = "master";
    hash = "sha256-yOqK13k7S/y5B96hVRJngNC13FIzUV4O/PTrZrQy/es=";
  };
}
