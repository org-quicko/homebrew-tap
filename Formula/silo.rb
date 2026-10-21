# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.6.2"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.2/silo-1.6.2-darwin-arm64.tar.gz"
      sha256 "b61b28277ad84856b5f83c7927036e7df98625cf1cb54d354f91d05d76f25f89"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.2/silo-1.6.2-darwin-x64.tar.gz"
      sha256 "81cd40065038545dd7554111a47209c6d4c0ac81aaa7f560517529f0978e9383"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.2/silo-1.6.2-linux-arm64.tar.gz"
      sha256 "e53533bd650b7cba4908ff4a4ed69c2c39bc6da795fd9f6e0d0ebdfb808561b6"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.6.2/silo-1.6.2-linux-x64.tar.gz"
      sha256 "4c092981bff8062c76ec0b7e35b201570251e1963c6d495049fd708c3d6d3a7b"
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
