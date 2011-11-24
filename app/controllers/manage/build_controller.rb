class Manage::BuildController < ApplicationController
  before_filter :check_installation

  def building
    redirect_to manage_install_index_path unless Dropboxr::Connector.connection.authorized?

    unless Dropboxr::Connector.connection.build
      return redirect_to error_manage_build_index_path
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
