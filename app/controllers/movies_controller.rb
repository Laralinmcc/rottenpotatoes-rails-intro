class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def ratings
    if params[:ratings] 
      rate = params[:ratings].keys
      session[:ratings] = rate
      return rate
    elsif session[:ratings] 
      return session[:ratings] 
    else
      @all_ratings
    end
  end

  def sort
    if params[:sort]
      session[:sort] = params[:sort]
      return params[:sort]
    elsif session[:sort]
      return session[:sort]
    else
      return "title"
    end 
  end

  def index
    @all_ratings = Movie.all_ratings
    @movies = Movie.where(:rating =>ratings).order(sort)
    if params[:sort] == "title"
      @title_header = 'hilite'
    elsif params[:sort] == "release_date"
      @release_date_header = 'hilite'
    end
    @checked_ratings = ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
