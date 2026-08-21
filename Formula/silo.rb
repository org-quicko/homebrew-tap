# GENERATED from packaging/homebrew/silo.rb.tmpl by scripts/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "0.2.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v0.2.0/silo-0.2.0-darwin-arm64.tar.gz"
      sha256 "ee3408268a468841b00874de0e73aa4821b1f2a3656108bb9110a722a7fb89b8"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v0.2.0/silo-0.2.0-darwin-x64.tar.gz"
      sha256 "bb2b78927901d04010885b0f43bdfee7184fc0251510893758e52b855b659a66"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v0.2.0/silo-0.2.0-linux-arm64.tar.gz"
      sha256 "8c0eb587eed2f806e8bc76ee871882846ae59e63c317a86a7f7c6534cf90166e"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v0.2.0/silo-0.2.0-linux-x64.tar.gz"
      sha256 "02f6bf6387a7f75acb052dc310f5a22133477d5b99a512089ecc70dcd85210e2"
    end
  end

  livecheck do
    url :homepage
    strategy :github_latest
  end

  def install
    bin.install "silo"
  end

  # `brew services` starts silo with an explicit data directory, because the
  # default is `./silo_data` relative to the working directory and a service has
  # no meaningful one. Everything a run produces — database, media, log — then
  # lives under Homebrew's prefix instead of wherever the user last stood.
  def post_install
    (var/"silo").mkpath
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"silo", "serve", "--data", var/"silo", "--log-file", var/"log/silo.log"]
    keep_alive true
    working_dir var/"silo"
    log_path var/"log/silo.log"
    error_log_path var/"log/silo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/silo version")

    # Offline, and it exercises the parts a broken build breaks first: argv
    # parsing, the config writer, and the filesystem.
    system bin/"silo", "init", "--config", testpath/"silo.toml"
    assert_path_exists testpath/"silo.toml"
  end
end
