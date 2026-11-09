class Curso{
    const inscriptos = #{}
    const cupoMaximo
    const docente

    method inscriptos() = inscriptos

    method docente() = docente

    method objetivo(estudiante)

    method recaudacion() = self.recaudacionBruta() - docente.honorarios(self)

    method recaudacionBruta() 

   method puedeInscribirse(estudiante) =
    !inscriptos.contains(estudiante)
    && inscriptos.size() < cupoMaximo
    && docente.estaHabilitado(estudiante, self)
    && self.objetivo(estudiante)

    method inscribir(estudiante){
    if(!self.puedeInscribirse(estudiante)){
        self.error("el estudiante no puede inscribirse en el curso")
    }
    inscriptos.add(estudiante)
}

    method menoresDeTrece() {
      return inscriptos.filter({estudiante => estudiante.edad() < 13}).size()
    }

    method cantidadDeInscriptos() = inscriptos.size()

    method inscriptoConEstilo(estilo) = inscriptos.any({inscripto => inscripto.tieneEstilo(estilo)}) 

    method esInfantil() = inscriptos.all({inscripto => inscripto.edad() < 13})
}

class Base inherits Curso{
    override method objetivo(estudiante){
        return estudiante.estilos().size() >= 1 || docente.esGuardavida()
    }

    override method recaudacionBruta(){
      return (self.cantidadDeInscriptos() * 20) - self.descuentoPorEstilo()
    }

    method descuentoPorEstilo() {
      return inscriptos.sum({inscripto => inscripto.descuentoPorEstilo()})
    }
}

class EscuelaDeNinios inherits Base{
    override method objetivo(estudiante) {
      return super(estudiante) && estudiante.edad() < 13
    }

    override method recaudacionBruta() = super() + 500
}

class Terapeutico inherits Curso{
  const recaudacionBruta
    const estilosRelajantes = [pecho, espalda]
    override method objetivo(estudiante){
        return estilosRelajantes.any({estilo => estudiante.estilos().contains(estilo)})
    }

    override method recaudacionBruta() = recaudacionBruta
}

class Docente{
    const esGuardavida
    method estaHabilitado(estudiante, curso) 
    method esGuardavida() = esGuardavida
    method honorarios(curso)

}

class Dedicado inherits Docente{
    const estilo
    override method estaHabilitado(estudiante, curso){
         return estudiante.tieneEstilo(estilo)
    }

    override method honorarios(curso) = 20 + (curso.recaudacionBruta() * 0.15)
}

class Externo inherits Docente{
    const cupoDeMenores
    override method estaHabilitado(estudiante, curso){
        return cupoDeMenores > curso.menoresDeTrece() || estudiante.edad() >= 13
    }

    override method honorarios(curso) = 20 + (curso.recaudacionBruta() * 0.1) + 3 * curso.cantidadDeInscriptos()
}

class Basico inherits Docente{
    override method estaHabilitado(estudiante, curso) = true

     override method honorarios(curso) = 20 + (curso.recaudacionBruta() * 0.1)
    }


class Estudiante{
const estilos 
const edad
method estilos() = estilos
method edad() = edad
method descuentoPorEstilo() = estilos.sum({estilo => estilo.descuentoPorEstilo()}) 
method tieneEstilo(estilo) = estilos.contains(estilo)

}


object crol {
  method descuentoPorEstilo() = 2
}
object pecho {
   method descuentoPorEstilo() = 2
}
object espalda{
   method descuentoPorEstilo() = 1
}
object mariposa{
   method descuentoPorEstilo() = 3
}

class Escuela{
  const cursos 
  var dinero

  method dinero() = dinero

  method cobrarRecaudacion() {
   dinero = dinero + self.recaudacion()
  }

  method recaudacion() {
    return cursos.sum({curso => curso.recaudacion()})
  }

  method cursoConEstilo(estilo) = cursos.find({curso => curso.inscriptoConEstilo(estilo)})

  method cursosInfantiles() = cursos.filter({curso => curso.esInfantil()})

  method docentesInfantiles() = self.cursosInfantiles().map({curso => curso.docente()}).asSet()
}