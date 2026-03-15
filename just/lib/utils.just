distro := `lsb_release -si`
distro_version := `lsb_release -sr`

#pm_install := 'sudo ' + `lib/pm-install`

sudo := require('sudo')

pm_install := if distro =~ "^(Debian|Ubuntu)$" {
  f"{{sudo}} apt install --no-upgrade --yes"
} else if distro == "Arch" {
  f"{{sudo}} pacman -S --needed --noconfirm"
} else {
  error(f"Unsupported distribution '{{distro}}'")
}

distro_is_debian := if distro == "Debian" { "true" } else { "false" }
distro_is_ubuntu := if distro == "Ubuntu" { "true" } else { "false" }
distro_is_arch := if distro == "Arch" { "true" } else { "false" }

_pm_install packages:
  {{pm_install}} {{replace(packages, "\n", ' ')}}
