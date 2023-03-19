using FilmesAPI.Data;
using FilmesAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FilmesAPI.Controllers
{
    [ApiController]
    [Route("[Controller]")]
    public class FilmeController : ControllerBase
    {
        private FilmeContext _context;
        private static List<Filme> filmes = new List<Filme>();

        public FilmeController(FilmeContext context)
        {
            _context = context;
        }

        [HttpPost]
        public IActionResult AdicionaFilme([FromBody] Filme filme)
        {
            _context.Filmes.Add(filme);
            _context.SaveChanges();
            return CreatedAtAction(nameof(RecuperaFilmesById),
                new { id = filme.Id },filme); 
        }

        [HttpGet("id")]
        public IActionResult RecuperaFilmesById(int id)
        {
            var filme = _context.Filmes.FirstOrDefault(filme => filme.Id == id);
            if(filme == null) return NotFound();
            return Ok(filme);  
        }

        [HttpGet]
        public IEnumerable<Filme> FilmesPaginate([FromQuery]int skip, [FromQuery] int take)
        {
            return _context.Filmes.Skip(skip).Take(take);
        }
    }
}
