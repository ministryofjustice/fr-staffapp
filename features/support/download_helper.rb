module DownloadHelpers
  TIMEOUT = 1
  PATH    = Rails.root.join('tmp', 'downloads')

  def downloads
    Dir[PATH.join("*")]
  end

  def download
    downloads.first
  end

  def download_content
    wait_for_download
    File.read(download)
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  def downloaded?
    !downloading? && downloads.any?
  end

  def downloading?
    downloads.grep(/\.part$/).any?
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end
  module_function :downloads, :download, :download_content, :wait_for_download, :downloaded?, :downloading?, :clear_downloads
end
