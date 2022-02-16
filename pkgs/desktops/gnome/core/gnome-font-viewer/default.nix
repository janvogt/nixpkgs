{ lib, stdenv, meson, ninja, gettext, fetchurl
, pkg-config, gtk3, glib, libxml2, gnome-desktop, adwaita-icon-theme, libhandy
, wrapGAppsHook, gnome, harfbuzz }:

stdenv.mkDerivation rec {
  pname = "gnome-font-viewer";
  version = "42.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "aNUBFJ63k+T8a7lqnYZZdja98Q6eKCA+LmT2QUPNSmk=";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkg-config gettext wrapGAppsHook libxml2 ];
  buildInputs = [ gtk3 glib gnome-desktop adwaita-icon-theme harfbuzz libhandy ];

  # Do not run meson-postinstall.sh
  preConfigure = "sed -i '2,$ d'  meson-postinstall.sh";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-font-viewer";
      attrPath = "gnome.gnome-font-viewer";
    };
  };

  meta = with lib; {
    description = "Program that can preview fonts and create thumbnails for fonts";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
