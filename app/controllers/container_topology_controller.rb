class ContainerTopologyController < ApplicationController
  before_action :check_privileges
  before_action :get_session_data
  after_action :cleanup_action
  after_action :set_session_data

  def show
    # When navigated here without id, it means this is a general view for all providers (not for a specific provider)
    # all previous navigation should not be displayed in breadcrumbs as the user could arrive from
    # any other page in the application.
    @breadcrumbs.clear if params[:id].nil?
    drop_breadcrumb(:name => _('Topology'), :url => '')
  end

  def index
    redirect_to :action => 'show'
  end

  def data
    render :json => {:data => generate_topology(params[:id])}
  end

  private

  def get_session_data
    @layout = "container_topology"
  end

  def set_session_data
    session[:layout] = @layout
  end

  def generate_topology(provider_id)
    ContainerTopologyService.new(provider_id).build_topology
  end
end
