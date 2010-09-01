class Attachment < ActiveRecord::Base
  
  belongs_to :person

  has_attachment :storage => :file_system, :max_size => 13.megabyte, :streaming => "false"
 
  validates_as_attachment
  
  # Read content of the attachment
  def get_attachment_content
    path = $attachments_location + self.public_filename
    
    @data = ""
    File.open(path, 'r+') do |f|
      @data << f.read
    end
    
    return @data

  end
  
  # Read content of the attachment in base64 format
  def get_attachment_content_in_base64
    
    @data = get_attachment_content
    
    return Base64.encode64(@data)

  end

end

class AttachmentsController < ApplicationController
  before_filter :login_required
  def add_attachment
    # get file name
    file_name = params[:qqfile]
    # get file content type
    att_content_type = (request.content_type.to_s == "") ? "application/octet-stream" : request.content_type.to_s
    # create temporal file
    file = Tempfile.new(file_name)
    # put data into this file from raw post request
    file.print request.raw_post
 
    # create several required methods for this temporal file
    Tempfile.send(:define_method, "content_type") {return att_content_type}
    Tempfile.send(:define_method, "original_filename") {return file_name}
       
    # save file into attachment
    attach = Attachment.new(:uploaded_data => file)
    attach.asset_id = params[:asset_id]
    attach.save!

    respond_to do |format|
      format.json{render(:layout => false , :json => {"success" => true, "data" => attach}.to_json )}
      format.html{render(:layout => false , :json => attach.to_json )}
    end
  rescue Exception => err
    respond_to do |format|
      format.json{render(:layout => false , :json => {"error" => err.to_s}.to_json )}
    end
  end
end