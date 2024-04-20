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
    let
      meta = {
        description = "Dash/Zeal docset for the Agda library '${name}'";
        license = lib.licenses.mit;
      };
    in
    runCommand "${name}-docset" { inherit meta; } ''
      ${agda-index}/bin/agda-index ${htmlDirectory} \
        --output-format docset \
        --main-page ${mainPage} \
        --library-name ${name}
      mkdir -p "$out"
      cp -r ${name}.docset "$out/"
    '';
}
