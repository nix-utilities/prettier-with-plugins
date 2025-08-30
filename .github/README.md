# Prettier With Plugins
[heading__top]:
  #prettier-with-plugins
  "&#x2B06; Nix re-packaging of prettier to enable plugins"


Nix re-packaging of prettier to enable plugins

## [![Byte size of Prettier With Plugins][badge__main__prettier_with_plugins__source_code]][prettier_with_plugins__main__source_code] [![Open Issues][badge__issues__prettier_with_plugins]][issues__prettier_with_plugins] [![Open Pull Requests][badge__pull_requests__prettier_with_plugins]][pull_requests__prettier_with_plugins] [![Latest commits][badge__commits__prettier_with_plugins__main]][commits__prettier_with_plugins__main] [![License][badge__license]][branch__current__license]


---


- [:arrow_up: Top of Document][heading__top]
- [:building_construction: Requirements][heading__requirements]
- [:zap: Quick Start][heading__quick_start]
- [&#x1F9F0; Usage][heading__usage]
- [&#x1F5D2; Notes][heading__notes]
- [:chart_with_upwards_trend: Contributing][heading__contributing]
  - [:trident: Forking][heading__forking]
  - [:currency_exchange: Sponsor][heading__sponsor]
- [:card_index: Attribution][heading__attribution]
- [:balance_scale: Licensing][heading__license]


---



## Requirements
[heading__requirements]:
  #requirements
  "&#x1F3D7; Prerequisites and/or dependencies that this project needs to function properly"


Install the NixOS and/or Nix package manager via official instructions;

> `https://nixos.org/nixos/manual/`


______


## Quick Start
[heading__quick_start]:
  #quick-start
  "&#9889; Perhaps as easy as one, 2.0,..."


Clone this project...


**Linux/MacOS**


```Bash
mkdir -vp ~/git/hub/nix-utilities

cd ~/git/hub/nix-utilities

git clone git@github.com:nix-utilities/prettier-with-plugins.git
```


______


## Usage
[heading__usage]:
  #usage
  "&#x1F9F0; How to utilize this repository"


> `home.nix` **(snippet)**

```nix
{ config, pkgs, lib, ... }:
let
  prettierCustomized = import /home/USER/git/hub/nix-utilities/prettier-with-plugins {
    inherit lib pkgs;

    ## Official
    enablePhp = true;
    enableRuby = true;
    enableXml = true;

    ## Third-party
    enableAstro = true;
    enableRust = true;
    enableSh = true;
    enableSolidity = true;
    enableSql = true;
    enableToml = true;
  };
in
{
  home-manager.users."yourName".config.programs.vim {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-prettier
    ];

    extraConfig = ''
      autocmd FileType php,ruby,xml,astro,rust,sh,solidity,sql,toml let b:prettier_exec_cmd = "prettier-stylelint"
      let g:prettier#exec_cmd_path = "${prettierCustomized}/bin/prettier"
    '';
  };
}
```

Then rebuild as usual!


______


## Notes
[heading__notes]:
  #notes
  "&#x1F5D2; Additional things to keep in mind when developing"


This repository may not be feature complete and/or fully functional, Pull
Requests that add features or fix bugs are certainly welcomed.


______


## Contributing
[heading__contributing]:
  #contributing
  "&#x1F4C8; Options for contributing to prettier-with-plugins and nix-utilities"


Options for contributing to prettier-with-plugins and nix-utilities


---


### Forking
[heading__forking]:
  #forking
  "&#x1F531; Tips for forking prettier-with-plugins"


Start making a [Fork][prettier_with_plugins__fork_it] of this repository to an
account that you have write permissions for.

- Add remote for fork URL. The URL syntax is
  _`git@github.com:<NAME>/<REPO>.git`_...


```Bash
cd ~/git/hub/nix-utilities/prettier-with-plugins

git remote add fork git@github.com:<NAME>/prettier-with-plugins.git
```

- Commit your changes and push to your fork, eg. to fix an issue...

```Bash
cd ~/git/hub/nix-utilities/prettier-with-plugins


git commit -F- <<'EOF'
:bug: Fixes #42 Issue


**Edits**


- `<SCRIPT-NAME>` script, fixes some bug reported in issue
EOF


git push fork main
```

> Note, the `-u` option may be used to set `fork` as the default remote, eg.
> _`git push -u fork main`_ however, this will also default the `fork` remote
> for pulling from too! Meaning that pulling updates from `origin` must be done
> explicitly, eg. _`git pull origin main`_

- Then on GitHub submit a Pull Request through the Web-UI, the URL syntax is
  _`https://github.com/<NAME>/<REPO>/pull/new/<BRANCH>`_

> Note; to decrease the chances of your Pull Request needing modifications
> before being accepted, please check the
> [dot-github](https://github.com/nix-utilities/.github) repository for
> detailed contributing guidelines.


---


### Sponsor
  [heading__sponsor]:
  #sponsor
  "&#x1F4B1; Methods for financially supporting nix-utilities that maintains prettier-with-plugins"


Thanks for even considering it!

Via Liberapay you may
<sub>[![sponsor__shields_io__liberapay]][sponsor__link__liberapay]</sub> on a
repeating basis.

Regardless of if you're able to financially support projects such as
prettier-with-plugins that nix-utilities maintains, please consider sharing
projects that are useful with others, because one of the goals of maintaining
Open Source repositories is to provide value to the community.


______


## Attribution
[heading__attribution]:
  #attribution
  "&#x1F4C7; Resources that where helpful in building this project so far."


- [GitHub -- `NixOS/nixpkgs#341798` -- `pretter` cannot find a plugin installed -- workaround by `benj9000`](https://github.com/NixOS/nixpkgs/issues/341798)
- [GitHub -- `github-utilities/make-readme`](https://github.com/github-utilities/make-readme)
- [Prettier Docs -- Plugins](https://prettier.io/docs/plugins/)


______


## License
[heading__license]:
  #license
  "&#x2696; Legal side of Open Source"


```
prettier-with-plugins: Nix re-packaging of prettier to enable plugins
Copyright (C) 2025 S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


For further details review full length version of [AGPL-3.0][branch__current__license] License.


---


### Plugin licenses as of 2025-08-29

#### Apache 2.0

- [`prettier-plugin-motoko`](https://github.com/dfinity/prettier-plugin-motoko)
- [`prettier-java`](https://github.com/jhipster/prettier-java)

#### BSD 3 Clause license

- [prettier-plugin-elm](https://github.com/gicentre/prettier-plugin-elm)

#### GPL 3.0

- [`prettier-plugin-sql-cst`](https://github.com/nene/prettier-plugin-sql-cst)

#### MIT

- [`@prettier/plugin-php`](https://github.com/prettier/plugin-php)
- [`@prettier/plugin-pug`](https://github.com/prettier/plugin-pug)
- [`@prettier/plugin-ruby`](https://github.com/prettier/plugin-ruby)
- [`@prettier/plugin-xml`](https://github.com/prettier/plugin-xml)
- [`prettier-plugin-apex`](https://github.com/dangmai/prettier-plugin-apex)
- [`prettier-plugin-astro`](https://github.com/withastro/prettier-plugin-astro)
- [`prettier-plugin-erb`](https://github.com/adamzapasnik/prettier-plugin-erb)
- [`prettier-plugin-gherkin`](https://github.com/mapado/prettier-plugin-gherkin)
- [`prettier-plugin-glsl`](https://github.com/NaridaL/glsl-language-toolkit/tree/main/packages/prettier-plugin-glsl)
- [`prettier-plugin-go-template`](https://github.com/NiklasPor/prettier-plugin-go-template)
- [`prettier-plugin-jinja-template`](https://github.com/davidodenwald/prettier-plugin-jinja-template)
- [`prettier-plugin-jsonata`](https://github.com/Stedi/prettier-plugin-jsonata)
- [`prettier-plugin-kotlin`](https://github.com/Angry-Potato/prettier-plugin-kotlin)
- [`prettier-plugin-prisma`](https://github.com/avocadowastaken/prettier-plugin-prisma)
- [`prettier-plugin-properties`](https://github.com/eemeli/prettier-plugin-properties)
- [`prettier-plugin-rust`](https://github.com/jinxdash/prettier-plugin-rust)
- [`prettier-plugin-sh`](https://github.com/un-ts/prettier/tree/master/packages/sh)
- [`prettier-plugin-solidity`](https://github.com/prettier-solidity/prettier-plugin-solidity)
- [`prettier-plugin-sql`](https://github.com/un-ts/prettier/tree/master/packages/sql)
- [`prettier-plugin-svelte`](https://github.com/sveltejs/prettier-plugin-svelte)
- [`prettier-plugin-toml`](https://github.com/un-ts/prettier/tree/master/packages/toml)




[branch__current__license]:
  /LICENSE
  "&#x2696; Full length version of AGPL-3.0 License"

[badge__license]:
  https://img.shields.io/github/license/nix-utilities/prettier-with-plugins

[badge__commits__prettier_with_plugins__main]:
  https://img.shields.io/github/last-commit/nix-utilities/prettier-with-plugins/main.svg

[commits__prettier_with_plugins__main]:
  https://github.com/nix-utilities/prettier-with-plugins/commits/main
  "&#x1F4DD; History of changes on this branch"

[prettier_with_plugins__community]:
  https://github.com/nix-utilities/prettier-with-plugins/community
  "&#x1F331; Dedicated to functioning code"

[issues__prettier_with_plugins]:
  https://github.com/nix-utilities/prettier-with-plugins/issues
  "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."

[prettier_with_plugins__fork_it]:
  https://github.com/nix-utilities/prettier-with-plugins/fork
  "&#x1F531; Fork it!"

[pull_requests__prettier_with_plugins]:
  https://github.com/nix-utilities/prettier-with-plugins/pulls
  "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"

[prettier_with_plugins__main__source_code]:
  https://github.com/nix-utilities/prettier-with-plugins/
  "&#x2328; Project source!"

[badge__issues__prettier_with_plugins]:
  https://img.shields.io/github/issues/nix-utilities/prettier-with-plugins.svg

[badge__pull_requests__prettier_with_plugins]:
  https://img.shields.io/github/issues-pr/nix-utilities/prettier-with-plugins.svg

[badge__main__prettier_with_plugins__source_code]:
  https://img.shields.io/github/repo-size/nix-utilities/prettier-with-plugins

[sponsor__shields_io__liberapay]:
  https://img.shields.io/static/v1?logo=liberapay&label=Sponsor&message=nix-utilities

[sponsor__link__liberapay]:
  https://liberapay.com/nix-utilities
  "&#x1F4B1; Sponsor developments and projects that nix-utilities maintains via Liberapay"

