class Content < ActiveRecord::Base

  def create_pages(files, wiki)
    # This selects all the text files in all the folders that were selected. It basically means
    # loading all of the files into memory. That could require A LOT of memory for large collections.
    # Alternative: save each text/volume as an object in db, then look it up when needed.

    volumes   = format_volumes(files)
    templates = volumes.delete('templates')
    WorkerManager.perform_async(volumes, templates, wiki) # it may be helpful to have a high-level worker so that we can track the upload progress
  end

#=================================================
  private
#=================================================

    def format_volumes(files)
      file_info   = extract_file_info(files) # we can't send file objects to sidekiq so we extract the important info into a hash
      text_files  = file_info.select { |file| File.extname(file[:filepath]) == '.txt' }
      volumes     = Hash.new{|h,k| h[k] = []}
      text_files.each do |file|
        path = file[:headers].match(/(filename=)("(.+)")/).captures.last
        root, volume, *misc, text_name = path.split('/') # EXAMPLE: wikipages/volume1/*/text-name
        volumes[volume] << { path: path, categories: misc, file: file }
      end
      volumes
    end

    def extract_file_info(files)
      files.map! do |file|
        { filepath: file.path, headers: file.headers, filename: file.original_filename }
      end
    end

end
