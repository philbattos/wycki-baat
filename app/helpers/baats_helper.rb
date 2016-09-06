module BaatsHelper

  def directory_info
    "Select the directory/folder that contains the files that you would like to use to create wiki pages. It should only contain other folders and/or txt/pdf/jpg/png files.Please only select folders that contain less than 128 files."
  end

  def wiki_url_info
    "Enter the sub-domain of the wiki where the pages will be created. For example, enter \"librarywiki\" for http://librarywiki.tsadra.org."
  end

  # def volume_number
  #   "Enter the total number of volumes to be created for this collection."
  # end

  def collection_info
    "Enter a name for the collection of volumes and texts. The name should be somewhat succinct since it will be used in page titles and content."
  end

end
