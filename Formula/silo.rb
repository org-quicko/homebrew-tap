# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.4.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.4.0/silo-1.4.0-darwin-arm64.tar.gz"
      sha256 "9dc652298cac344a6e0f14801445a330b10cf5531a01319fcd536456fc6df583"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.4.0/silo-1.4.0-darwin-x64.tar.gz"
      sha256 "3f9fda58223f0a7f4b38f474c140708b0f7fa5ec17390bb80b8bb13fcb6a072c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.4.0/silo-1.4.0-linux-arm64.tar.gz"
      sha256 "7b7dd1c8e516c7ae40692af2f5fae00e438ec275f7f02cff2b52c3887faa7027"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.4.0/silo-1.4.0-linux-x64.tar.gz"
      sha256 "d0ec7c0957349758eda85df2342ac77b0918649e4ca213a8c538fb4bb964f7c3"
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
