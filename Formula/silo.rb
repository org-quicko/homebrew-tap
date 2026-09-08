# GENERATED from packaging/homebrew/silo.rb.tmpl by tools/render-formula.ts.
# Edit the template in org-quicko/silo, not this file: the release workflow
# overwrites it on every tag.
class Silo < Formula
  desc "Minimal, self-hostable headless CMS with JSON Schema collections"
  homepage "https://github.com/org-quicko/silo"
  version "1.0.0"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-darwin-arm64.tar.gz"
      sha256 "a7c4f4beaa219daa83cdf8e6c14e0f5c93ba370600aba4337950973acaf04306"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-darwin-x64.tar.gz"
      sha256 "8b1803f231b9c6971f742f509b116ca7b534a61a3c3175458632f70f2f49f8c4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-arm64.tar.gz"
      sha256 "fdaf8dbb18542164292fa05f8d6c12cfd5b5f0d25329aedd8d921842c86087e7"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-x64.tar.gz"
      sha256 "030502b549d6fe0f3f3a312f0ea7b90ea3dc643c7b8fc961d854af0f99db0e7e"
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
