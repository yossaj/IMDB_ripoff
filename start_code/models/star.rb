require_relative('../db/sql_runner.rb')
require_relative('movie')

class Star
  attr_reader :id
  attr_accessor :first_name, :last_name

  def initialize(options)
    @first_name = options["first_name"]
    @last_name = options["last_name"]
    @id = options["id"].to_i if options["id"]
  end

  def save()
    sql = "INSERT INTO stars(first_name,last_name) VALUES ($1, $2) RETURNING id;"
    values =[ @first_name, @last_name]
    results = SqlRunner.run(sql,values).first
    @id = results['id'].to_i
  end

  def update
    sql = " UPDATE stars SET (first_name, last_name) =($1,$2) WHERE id = $3"
    values = [@first_name,@last_name,@id]
    SqlRunner.run(sql, values )
  end

  def all_movies
    sql = "SELECT movies.* FROM movies
          INNER JOIN castings
          ON castings.movie_id = movies.id
          WHERE castings.star_id = $1"
    values = [@id]
    movies = SqlRunner.run(sql, values)
    result = movies.map{|movie| Movie.new(movie)}
    return result
  end



  def self.delete_all()
    sql = "DELETE FROM stars;"
    SqlRunner.run(sql)
  end


    def self.all()
      sql = "SELECT * FROM stars"
      results = SqlRunner.run(sql)
      stars = results.map{|star| Star.new(star)}
      return stars
    end

end
