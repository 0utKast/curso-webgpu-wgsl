---
name: gimp-asset-creator
description: Habilidad para diseñar y generar recursos gráficos originales (imágenes de prueba, fondos, sujetos recortables, fotos de retoque) adaptados a cada tutorial práctico de GIMP.
---

# Generador de Recursos Gráficos para Tutoriales de GIMP

## Descripción
Esta habilidad define el protocolo para concebir, diseñar y generar imágenes 100% originales destinadas a las prácticas paso a paso de la serie de tutoriales de GIMP. Asegura que cada lección cuente con activos visuales atractivos, adaptados a la técnica específica explicada (transformación, selección, capas, máscaras o retoque).

---

## Directrices por Tipo de Vídeo / Técnica

### Vídeo 1: Interfaz, Lienzo y Banner Web
- **Tipo de imagen**: Fotografía de paisaje urbano o naturaleza moderna con buena composición horizontal.
- **Relación de aspecto**: `16:9`
- **Criterio visual**: Gran riqueza cromática y contraste, ideal para escalar, mover y reencuadrar dentro de un lienzo de 1200x630 px.

### Vídeo 2: Herramientas de Selección y Recorte
- **Tipo de imagen**: Objeto o personaje destacado sobre fondo croma de alto contraste (verde croma o color sólido brillante opuesto al objeto).
- **Relación de aspecto**: `4:3` o `1:1`
- **Criterio visual**: Bordes perfectamente definidos sobre fondo uniforme de contraste para garantizar que la Selección Difusa y Selección por Color funcionen de forma impecable en la demostración pedagógica.

### Vídeo 3: Capas y Modos de Fusión
- **Tipo de imagen**: Pareja de imágenes complementarias (ej. silueta con paisaje o textura geométrica/orgánica).
- **Relación de aspecto**: `16:9` o `3:4`
- **Criterio visual**: Zonas claras y oscuras contrastadas para demostrar de forma evidente los modos *Multiplicar*, *Pantalla* y *Superponer*.

### Vídeo 4: Máscaras de Capa y Retoque No Destructivo
- **Tipo de imagen**: Paisaje con cielo dramático o escena con iluminación dual.
- **Relación de aspecto**: `16:9`
- **Criterio visual**: Gradiente natural de luces a sombras para practicar transiciones con la herramienta de degradado sobre la máscara de capa.

### Vídeo 5: Retoque y Restauración
- **Tipo de imagen**: Retrato o escena vintage/clásica con detalles de textura fina.
- **Relación de aspecto**: `4:3` o `1:1`
- **Criterio visual**: Áreas con tonos de piel o texturas para practicar el pincel de saneado, clonado y ajuste de curvas de nivel.

---

## Procedimiento de Generación de Activos
1. Formular el prompt en inglés especificando estilo fotográfico profesional, resolución alta y composición limpia.
2. Invocar la herramienta de generación de imagen (`generate_image`).
3. Registrar el activo y vincularlo en la documentación del guión correspondiente.
