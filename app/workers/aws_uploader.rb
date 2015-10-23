class AWSUploader
  include Sidekiq::Worker

  def perform(path)
    puts path
    # pdf = PdfOriginal.find(pdf_id)
    pdf = PdfOriginal.new
    file = File.open(path)
    pdf.pdf_file = file
    pdf.save!

    puts "File uploaded: #{pdf.pdf_file.url}"

    ActionCable.server.broadcast 'alerts',
      message: "PDF successfully stored on S3: #{pdf.pdf_file_identifier}",
      html_class: "success",
  end
end