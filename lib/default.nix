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
    }:
    runCommand "${name}-docset" { } ''
      ${agda-index}/bin/agda-index ${htmlDirectory} \
        --output-format docset \
        --library-name ${name}
      mkdir -p "$out"
      cp -r ${name}.docset "$out/"
    '';
}
