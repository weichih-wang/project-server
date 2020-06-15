require 'filemagic'
require "image_processing/mini_magick"

module Api
  class FloorplansController < ApplicationController
    def index
      floorplans = Project.find(params[:project_id]).floorplans
      render json: {status: 'SUCCESS', data: floorplans}, status: :ok
    end

    def show
      begin
        floorplan = Floorplan.find_by(id: params[:id], project_id: params[:project_id])
        render json: {status: 'SUCCESS', data: floorplan}, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {status: 'ERROR'}, status: :not_found
      end
    end

    def image
      puts params
      begin
        floorplan = Floorplan.find_by(id: params[:floorplan_id], project_id: params[:project_id])
        case params[:path]
        when "thumb"
          image = floorplan.thumb
        when "large"
          image = floorplan.large
        when "original"
          image = floorplan.original
        else
          render json: {status: 'ERROR'}, status: :not_implemented
          return
        end
        
        send_data image.download, filename: image.filename.to_s, content_type: image.content_type
      rescue ActiveRecord::RecordNotFound => e
        render json: {status: 'ERROR'}, status: :not_found
      end
    end

    def update
      begin
        floorplan = Floorplan.find_by(id: params[:id], project_id: params[:project_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: {status: 'ERROR'}, status: :not_found
      end
      floorplan.name = floorplan_params[:name] if floorplan_params[:name]
      if floorplan_params[:original]
        thumbImage = ImageProcessing::MiniMagick
          .source(floorplan_params[:original])
          .resize_to_fill(100, 100)
          .convert("png")
          .call
        floorplan.thumb.attach(io: thumbImage, filename: "thumb.png", content_type: "image/png")
        largeImage = ImageProcessing::MiniMagick
          .source(floorplan_params[:original])
          .resize_to_fill(1000, 1000)
          .convert("png")
          .call
        floorplan.large.attach(io: largeImage, filename: "large.png", content_type: "image/png")
      end
      if floorplan.save
        render json: {status: 'SUCCESS', data: floorplan}, status: :ok
      else
        render json: {status: 'ERROR'}, status: :unprocessable_entity
      end
    end

    def create
      floorplan = Floorplan.new(floorplan_params)
      thumbImage = ImageProcessing::MiniMagick
        .source(floorplan_params[:original])
        .resize_to_fill(100, 100)
        .convert("png")
        .call
      floorplan.thumb.attach(io: thumbImage, filename: "thumb.png", content_type: "image/png")
      largeImage = ImageProcessing::MiniMagick
        .source(floorplan_params[:original])
        .resize_to_fill(1000, 1000)
        .convert("png")
        .call
      floorplan.large.attach(io: largeImage, filename: "large.png", content_type: "image/png")
      if floorplan.save
        render json: {status: 'SUCCESS', data: floorplan}, status: :ok
      else
        render json: {status: 'ERROR'}, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        floorplan = Floorplan.find_by(id: params[:id], project_id: params[:project_id])
        floorplan.destroy
        render json: {status: 'SUCCESS'}, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {status: 'ERROR'}, status: :not_found
      end
    end

    private
    def floorplan_params
      params[:original] = params[:image]
      params.permit(:original, :name, :project_id)
      
    end
  end
end