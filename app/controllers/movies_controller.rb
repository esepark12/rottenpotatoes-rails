class MoviesController < ApplicationController


  #HW Part 1#
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index #index.html
    @movies = Movie.all
    ######added
    @all_ratings = Movie.all_ratings #
    @ratings_to_show = params[:ratings] || {} 
    ratings_list = @ratings_to_show
    if @ratings_to_show == {}
      ratings_list = Hash[@all_ratings.map {|x| [x, 1]}] #assign any value
    end
    #update movies filtered by ratings
    
    @movies = Movie.with_ratings(ratings_list.keys)
    ######
    @clicked_header = params[:clicked_header] || ""
    @release_date_header = params[:release_date_header] || ""
    #sort movies in order
    if @clicked_header == "title_header"
      @movies = @movies.order(:title)
    end
    if @release_date_header != ""
      @movies = Movie.order(:release_date)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
