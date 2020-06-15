module Api
  class ProjectsController < ApplicationController
    def index
      projects = Project.all
      render json: {status: 'SUCCESS', data: projects}, status: :ok
    end

    def show
      begin
        project = Project.find(params[:id])
        render json: {status: 'SUCCESS', data: project}, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {status: 'ERROR'}, status: :not_found
      end
    end

    def create
      project = Project.new(project_params)
      if project.save
        render json: {status: 'SUCCESS', data: project}, status: :ok
      else
        render json: {status: 'ERROR'}, status: :unprocessable_entity
      end
    end

    def update
      begin
        project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {status: 'ERROR'}, status: :not_found
      end

      project.name = project_params[:name] if project_params[:name]
      if project.save
        render json: {status: 'SUCCESS', data: project}, status: :ok
      else
        render json: {status: 'ERROR'}, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        project = Project.find(params[:id])
        project.destroy
        render json: {status: 'SUCCESS'}, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {status: 'ERROR'}, status: :not_found
      end
    end

    private
    def project_params
      params.permit(:name)
    end
  end
end