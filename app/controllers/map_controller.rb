ActionController::Renderers.add :csv do |csv, options|
  self.content_type ||= Mime::CSV
  self.response_body  = csv.respond_to?(:to_csv) ? csv.to_csv : csv
end

class MapController < ApplicationController
  # http_basic_authenticate_with name: 'admin', password: 'secret'
  # caches_action :index, expires_in: 1.hour
  # caches_action :plot, expires_in: 1.hour
  # caches_action :data, expires_in: 1.hour
  def index
    unless current_admin_user
      # authenticate_or_request_with_http_token do |token, options|
      #   current_admin_user = User.find_by(auth_token: token)
      # end
    end
    if current_admin_user
      @tags = current_admin_user.all_tags
      @floors = current_admin_user.all_floors.sort{|a,b| a.name <=> b.name}
      @buildings = @floors.map { |f| f.building }.uniq.sort{|a,b| a.name <=> b.name}
      @projects = @buildings.map { |b| b.project }.uniq.sort{|a,b| a.name <=> b.name}
      @customers = @projects.map { |p| p.customer }.uniq.sort{|a,b| a.name <=> b.name}
      redirect_to new_admin_customer_path, notice: 'You have no customers added yet' and return if @customers.empty?
      redirect_to new_admin_project_path, notice: 'You have no projects added yet' and return if @projects.empty?
      redirect_to new_admin_building_path, notice: 'You have no buildings added yet' and return if @buildings.empty?
      redirect_to new_admin_floor_path, notice: 'You have no floors added yet' and return if @floors.empty?
      respond_to do |format|
        format.html { render }
        format.json { render json: @customers.to_json(include: {projects: {include: {buildings: {include: {floors: {methods: :url, include: :tags}}}}}}) }
      end
    else
      redirect_to new_admin_user_session_path, notice: 'Please login first'
    end
  end

  def plot
    unless current_admin_user
      # authenticate_or_request_with_http_token do |token, options|
      #   current_admin_user = User.find_by(auth_token: token)
      # end
    end
    if current_admin_user
      @types = {temp: 'Temperature', humidity: 'Humidity', zone: 'Comfort Zone'}
      @tags = current_admin_user.all_tags.select{|tag| tag.logs.count > 0}
      @floors = current_admin_user.all_floors.sort{|a,b| a.name <=> b.name}
      @buildings = @floors.map { |f| f.building }.uniq.sort{|a,b| a.name <=> b.name}
      @projects = @buildings.map { |b| b.project }.uniq.sort{|a,b| a.name <=> b.name}
      @customers = @projects.map { |p| p.customer }.uniq.sort{|a,b| a.name <=> b.name}
      redirect_to new_admin_customer_path, notice: 'You have no customers added yet' and return if @customers.empty?
      redirect_to new_admin_project_path, notice: 'You have no projects added yet' and return if @projects.empty?
      redirect_to new_admin_building_path, notice: 'You have no buildings added yet' and return if @buildings.empty?
      redirect_to new_admin_floor_path, notice: 'You have no floors added yet' and return if @floors.empty?
      respond_to do |format|
        format.html { render }
        format.json { render json: @customers.to_json(include: {projects: {include: {buildings: {include: {floors: {methods: :url, include: :tags}}}}}}) }
      end
    else
      redirect_to new_admin_user_session_path, notice: 'Please login first'
    end
  end

  def data
    mode = params[:type]
    uids = params[:uids].split('+')
    tags = Tag.where uid: uids
    column_names = ['Date'] + tags.pluck(:name)
    total = uids.count
    data = {}
    if current_admin_user
      tags.each_with_index do |e, i|
        temp = e.data mode
        temp.each do |log|
          data[log[0]] = Array.new total, 'NaN' unless data[log[0]]
          data[log[0]][i] = log[1]
        end
      end
    end
    data = data.map{|e| e.flatten}.sort
    csv = CSV.generate do |csv|
      csv << column_names
      data.each do |log|
        csv << log
      end
    end
    render csv: csv
  end

  def diffdata
    uid = params[:uid]
    tag = Tag.find_by_uid uid
    column_names = ['Date', uid]
    data = tag.diff_data params[:from], params[:to]
    csv = CSV.generate do |csv|
      csv << column_names
      data.each do |log|
        csv << log
      end
    end
    render csv: csv
  end

  def graph
    @tag = Tag.find_by_uid params[:uid]
    @reference = @tag.project.tag
    flash.now[:error] = "Project '#{@tag.project}' doesn't have any reference tag set yet!" if @reference.nil?
  end
end
