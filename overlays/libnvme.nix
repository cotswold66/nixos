{pkgs, config, ...}:

{
  nixpkgs.overlays = [
    # ( final: prev:
    #   {
    #     libnvme = prev.libnvme.overrideAttrs (old: {
    #       patches = (old.patches or []) ++ [
    #         (prev.fetchpatch {
    #           url = "https://github.com/linux-nvme/libnvme/pull/727.patch";
    #           hash = "sha256:0SrR1++QTXNq+X4YOpW3JzEjFdSSBdqPl/xI2zdcvTs=";
    #         })
    #       ];
    #     });
    #   } )
    # ( final: prev:
    #   {
    #     libblockdev = prev.libblockdev.overrideAttrs (old: {
    #       patches = (old.patches or []) ++ [
    #         (prev.fetchpatch {
    #           url = "https://github.com/storaged-project/libblockdev/pull/969.patch";
    #           hash = "sha256:LHeotKzcRDdT/GhH3JdVjX/7ZMN1ghllYuaxPYsCZMY=";
    #         })
    #       ];
    #     });
    #   } )
  ];
}
