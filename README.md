# Agda docsets for Dash/Zeal

This repository contains instructions for generating [docsets](https://kapeli.com/docsets)
of Agda libraries for the documentation viewers [Dash](https://kapeli.com/dash)
and [Zeal](https://zealdocs.org/).

Currently, this repository builds docsets for the following libraries:

* [`standard-library`](https://github.com/agda/agda-stdlib):
    The Agda standard library,
    version [v2.0](https://github.com/agda/agda-stdlib/releases/tag/v2.0)
* [`cubical`](https://github.com/agda/cubical):
    A standard library for Cubical Agda,
    version [v0.7](https://github.com/agda/cubical/releases/tag/v0.7)

## Generating docsets

With [Nix](https://nixos.org/) installed and [Flakes enabled](https://wiki.nixos.org/wiki/Flakes), run

```shellsession
$ nix build
```

For each library `<lib>`, the directory `result/<lib>-docset/` will contain the corresponding docset,
i.e. a folder named `<lib>.docset`.

To generate individual docsets, run

```shellsession
$ nix build '.#<lib>-docset'
```

## Installing docsets

To install a docset with Zeal, copy the generated `<lib>.docset` folder into `"${XDG_DATA_HOME}/Zeal/Zeal/docsets"`,
If `${XDG_DATA_HOME}` is unset, copy the docset folder to `$HOME/.local/share/Zeal/Zeal/docsets`.

## License

The files in this repository are licensed under the terms of the [MIT license](./LICENSE).
