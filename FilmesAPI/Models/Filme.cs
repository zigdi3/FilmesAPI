using System.ComponentModel.DataAnnotations;

namespace FilmesAPI.Models
{
    public class Filme
    {
        [Key]
        public int Id { get; set; }
        [Required (ErrorMessage = "O título é obrigatorio")]
        public string Titulo { get; set; }
        [Required(ErrorMessage = "O Gênero é obrigatorio")]
        [MaxLength(50, ErrorMessage = "O tamanho do genero nao pode exceder 50 caracteres")]
        public string Genero { get; set; }
        [Required]
        [Range(70, 600, ErrorMessage = "A duracao dever ser entre 70 minutos e 10 horas")]
        public string Duracao { get; set; }
        
    }
}
