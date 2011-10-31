class Manage::BuildController < ApplicationController
  before_filter :check_installation

  def building
    dbr_conn = dropboxr_conn
    
    if dbr_conn.authorized?
      begin
        galleries = dbr_conn.collect(['/Photos/iPod Photo Cache'])

        galleries.each do |gallery|
          album = Album.find_or_create_by_name gallery.name
          album.path = gallery.path

          album.save

          puts "Building :: #{album.modified} != #{gallery.modified}"

          if album.valid?
            if album.modified != gallery.modified.to_s
              puts "Creating or Updating #{album.name} modified on: #{gallery.modified.to_s} <> #{album.modified}"

              gallery.photos.each do |item|
                photo = album.photos.find_or_create_by_path(item.path)

                if photo.name.nil? || photo.modified != item.modified # photo not in db or modification date is updated
                  if photo.name.nil? # new
                    photo.name = item.name
                    photo.path = item.path

                    puts "Photo :: Creating #{photo.path} ..."
                  else
                    photo.updated = true
                    
                    puts "Photo :: Updating #{photo.path} ..."
                  end

                  photo.revision = item.revision
                  photo.modified = item.modified

                  photo.save
                end
              end
              
              album.modified = gallery.modified
              album.save
              
              puts "Gallery :: Saved #{album.name}"
            end
          else
            puts "Gallery :: Not saved"
            p album.errors
          end
        end
      rescue Exception => e
        p e

        return redirect_to error_manage_build_index_path
      end 
    else
      return redirect_to manage_install_index_path
    end

    redirect_to done_manage_build_index_path
  end

  def done
  end

  def error
  end

  private

    def check_installation
      redirect_to root_path if Installation.installed.empty?
    end

end
