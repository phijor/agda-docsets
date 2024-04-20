{
  lib,
  agda-index,
  runCommand,
}:
{
  mkDocset =
    drv:
    {
      name ? drv.name,
      htmlDirectory ? lib.getOutput "html" drv,
      mainPage ? "index.html",
    }:
    runCommand "${name}-docset" { } ''
      ${agda-index}/bin/agda-index ${htmlDirectory} \
        --output-format docset \
        --main-page ${mainPage} \
        --library-name ${name}
      mkdir -p "$out"
      cp -r ${name}.docset "$out/"
    '';
}
