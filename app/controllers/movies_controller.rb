class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    if params[:order]=="title"
      @movies=Movie.all.order(params[:order])
      @highlight_title = "hilite"
    elsif params[:order]=="release_date"
      @movies=Movie.all.order(params[:order])
      @highlight_date = "hilite"
    else
      @movies = Movie.all
    end
    if params[:ratings]
      @ratings=params[:ratings]
      @movies=@movies.where(rating: @ratings.keys)
    else
      @ratings=Hash[@all_ratings.collect {|rating| [rating, rating]}]
      @movies=@movies
    end
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
