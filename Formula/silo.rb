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
      sha256 "54bd9f4db1a519c568214b2eb26d7ac90a977f2804aff8a766b8ce25454d5c2d"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-darwin-x64.tar.gz"
      sha256 "ec8fc9e0d7d576fc75a4ce7f36d910f678d36d6050d45b29851c5e5354c6d134"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-arm64.tar.gz"
      sha256 "95a349b78a62da8c6f5b119a88b6e99fbc1000c40ee277e5bdd38102f3fcea44"
    end
    on_intel do
      url "https://github.com/org-quicko/silo/releases/download/v1.0.0/silo-1.0.0-linux-x64.tar.gz"
      sha256 "e4bc7b9b55e823058d6c1a7ff7920a62b1172c82389eb35c111fedab2f25ac0f"
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
