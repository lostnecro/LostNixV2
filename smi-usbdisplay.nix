# Pacote do driver Silicon Motion (SM768) — SMIUSBDisplayManager
# Coloque o .zip baixado da Silicon Motion na mesma pasta deste arquivo
# e ajuste o nome em `src` se a versão for diferente.
{ lib
, stdenv
, unzip
, autoPatchelfHook
, makeWrapper
, libusb1
, libdrm
, evdi            # passado pelo módulo: config.boot.kernelPackages.evdi
}:

stdenv.mkDerivation {
  pname = "smi-usbdisplay";
  version = "2.24.8.0";

  src = ./SMI-USB-Display-for-Linux-v2.24.8.0.zip;

  nativeBuildInputs = [ unzip autoPatchelfHook makeWrapper ];
  buildInputs = [ libusb1 libdrm evdi stdenv.cc.cc.lib ];

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src -d zip
    run=$(find zip -name 'SMIUSBDisplay-driver*.run' | head -n1)
    sh "$run" --noexec --target extracted
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/smiusbdisplay $out/bin

    # binário x86_64 do gerenciador
    mgr=$(find extracted -name SMIUSBDisplayManager -type f \
            | grep -Ei 'x64|x86_64|amd64' | head -n1)
    [ -z "$mgr" ] && mgr=$(find extracted -name SMIUSBDisplayManager -type f | head -n1)
    cp -r "$(dirname "$mgr")"/. $out/lib/smiusbdisplay/
    chmod +x $out/lib/smiusbdisplay/SMIUSBDisplayManager

    # firmware do adaptador — o binário procura em /opt/siliconmotion/
    # (o módulo cria links para cá via tmpfiles)
    cp extracted/*.bin $out/lib/smiusbdisplay/

    # remove bibliotecas de outras arquiteturas, se vierem junto
    find $out/lib/smiusbdisplay -name '*.so*' -exec sh -c \
      'file "$1" | grep -q x86-64 || rm -f "$1"' _ {} \; 2>/dev/null || true

    # nixpkgs' evdi only ships libevdi.so, but its SONAME (and what the
    # manager links against) is libevdi.so.1 — provide that name.
    # (Must come after the cleanup above, which would delete a symlink.)
    ln -sf ${evdi}/lib/libevdi.so $out/lib/smiusbdisplay/libevdi.so.1

    makeWrapper $out/lib/smiusbdisplay/SMIUSBDisplayManager $out/bin/SMIUSBDisplayManager \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ evdi libusb1 libdrm ]}
    runHook postInstall
  '';

  meta = {
    description = "Silicon Motion SM76x/SM77x USB display driver (userspace)";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
