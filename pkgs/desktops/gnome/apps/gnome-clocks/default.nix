{ lib, stdenv
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, wrapGAppsHook
, itstool
, desktop-file-utils
, vala
, gobject-introspection
, libxml2
, gtk3
, glib
, gsound
, sound-theme-freedesktop
, gsettings-desktop-schemas
, adwaita-icon-theme
, gnome-desktop
, geocode-glib
, gnome
, gdk-pixbuf
, geoclue2
, libgweather
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "gnome-clocks";
  version = "42.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "gZriRRfuGnNe4w5ntHgp1x3b40eC1lyIPJxj0+xwW9g=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook
    desktop-file-utils
    libxml2
    gobject-introspection # for finding vapi files
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    gdk-pixbuf
    adwaita-icon-theme
    gnome-desktop
    geocode-glib
    geoclue2
    libgweather
    gsound
    libhandy
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Fallback sound theme
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
    )
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-clocks";
      attrPath = "gnome.gnome-clocks";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Clocks";
    description = "Clock application designed for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
