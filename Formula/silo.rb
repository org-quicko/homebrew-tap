# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.6.1"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.1/silo-1.6.1-darwin-arm64.tar.gz"
      sha256 "4dd9f3aa3ea6e8c6f7da3b5f934784921e1475791b3d5d25966a79eba4a46eb9"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.1/silo-1.6.1-darwin-x64.tar.gz"
      sha256 "dc817ee0f7f31d948d7c6a7d798e2fbb12a8e02c30dd1e8d912915a3eff58984"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.1/silo-1.6.1-linux-arm64.tar.gz"
      sha256 "290b99431201407d71a2ea294f4aa6bfa9572e0f5b3cd9a493005ff191f9f16b"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.1/silo-1.6.1-linux-x64.tar.gz"
      sha256 "e60f8f7789d5b0c96fe20cd087ac04a533177ab4ce09a8cd12bbcb109f7c0eed"
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
