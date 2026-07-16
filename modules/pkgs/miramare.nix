{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "miramare";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "franbach";
    repo = "miramare";
    rev = "master";
    hash = "sha256-CPxBeeWOryhSlocNZwHf2EZkdRv6LvhLu9jO+IjuzSg=";
  };
}
