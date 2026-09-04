# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.0.1"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.1/silo-1.0.1-darwin-arm64.tar.gz"
      sha256 "fc70d2845afb919232842e755422b60b7f19d6992e9df0b859629df048c66fea"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.1/silo-1.0.1-darwin-x64.tar.gz"
      sha256 "da2e523976f6252ad04b34e4ff309a2413d664e04edd6b32ade1e073b3f864d9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.1/silo-1.0.1-linux-arm64.tar.gz"
      sha256 "560a0d0638bb00b74445e416c10bdbab366d9421debdc2910234afe5b211470f"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.1/silo-1.0.1-linux-x64.tar.gz"
      sha256 "54faad6f19cf08884e685a048bdc8a899be2246a0d892ecf58c0053f4fffb026"
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
