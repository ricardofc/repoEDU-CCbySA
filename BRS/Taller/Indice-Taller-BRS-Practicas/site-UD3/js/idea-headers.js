document.addEventListener('DOMContentLoaded', function () {
  // Función para numerar los títulos de un artículo
  function numerarArticulo(articulo, nivelPadre = 0, numeroPadre = 0) {
    const headers = articulo.querySelectorAll('h1, h2, h3, h4, h5, h6');
    let numero = numeroPadre + 1;

    headers.forEach(function (header) {
      const nivel = parseInt(header.tagName.substring(1)) - 1;

      // Actualiza el número basado en el nivel del padre
      numero = numeroPadre > 0 ? `${numeroPadre}.${numero}` : numero;

      // Reinicia contadores de niveles inferiores
      for (let i = nivel + 1; i < 6; i++) {
        contador[i] = 0;
      }

      // Agrega el número al inicio del título
      header.textContent = `${numero} ${header.textContent}`;
    });
  }

  // Función principal para numerar todos los títulos
  function numerarTitulos() {
    // Obtener la estructura de la navegación del mkdocs.yml
    const nav = window.mkdocs.navigation; // Ajustar según tu tema de MkDocs

    // Inicializar el contador para cada nivel de encabezado
    const contador = [0, 0, 0, 0, 0, 0];

    // Recorrer la navegación y numerar artículos
    nav.forEach((item, nivelPadre) => {
      const articulo = document.querySelector(`article[data-path="${item.href.replace('./', '')}"]`);
      if (articulo) {
        numerarArticulo(articulo, nivelPadre);
      }
    });
  }

  // Mostrar el contenido de los artículos
  function mostrarContenido() {
    const articles = document.querySelectorAll('article');
    articles.forEach(article => {
      article.style.visibility = "visible";
      article.style.display = "block";
    });
  }

  // Ejecutar las funciones
  numerarTitulos();
  mostrarContenido();

  // Mostrar el contenido al imprimir
  window.addEventListener('beforeprint', mostrarContenido);
});
