---
trigger: always_on
---

---
name: Reglas de Proyecto Fiumicello
description: Reglas estrictas de diseño, codificación y arquitectura para el proyecto fiumicello_app
---

# Reglas Específicas del Proyecto Fiumicello

Estas reglas deben seguirse siempre que se interactúe con el código de esta aplicación.

## 1. Estilos y Colores
- **Colores:** NUNCA usar colores genéricos quemados en el código (como `Colors.blue` o `Colors.red`). Usar *exclusivamente* los colores definidos en la paleta de la aplicación (ej. `AppColors.gold`, `AppColors.darkBackground`). Si es necesario para recrear un diseño especifico debes crear el color en AppColors.
Debes tener en cuenta que cada panatalla que se muestra en la aplicacion debe tener la posibilidad de mostrarse en dos paletas de colores dark para la noche y Light para el dia. en AppColors encontraras las especificaciones para cada una de ellas.
- **Textos:** TODO texto en la aplicación debe usar el widget personalizado `normalText`. No crear instancias puras de `Text(...)` con estilos sobrescritos a menos que sea estrictamente necesario.
- **copyWith:** Evitar el uso de `.copyWith` en estilos de texto. Si un estilo no existe en `AppTextStyles`, agregar el parámetro requerido allí (ej. `fontSize` por defecto a 14).

## 2. Arquitectura (Soft Delete)
- Al implementar borrados en bases de datos o APIs, usar **Soft Delete** (desactivación lógica).
- **Métodos HTTP:** Usar `PATCH` en lugar de `DELETE` para estas acciones.
- **Rutas:** Las rutas de desactivación deben seguir el formato `/recurso/:id/deactivate`.
- **Nomenclatura:** Los métodos en el código deben llamarse `deactivate`, no `remove` ni `delete`.

## 3. UI y Componentes Visuales
- **Modales:** Los modales (ej. crear cuenta, login) deben tener consistencia visual. Mantener el borde y los colores de texto acordes al diseño principal (ej. color dorado para textos de acción y bordes).
- Mantener uniformidad general basada en los diseños de la carpeta `OnBoarding`.

## 4. Dependencias y Manejo de Estado
- (Agrega aquí tus reglas sobre Riverpod, Provider, BLoC, etc.)
- (Agrega aquí reglas sobre cómo nombrar archivos: ej. `snake_case` para archivos y `PascalCase` para clases).

## 5. Estructura de Páginas y Scaffolds
- **Uso de Scaffold:** Los widgets `Scaffold` **únicamente** seran desktop_scaffold, mobile_scaffold y tablet_scaffold, estas estan ligadas a la carpeta responsive la cual se encarga de adaptar la UI a diferentes tamaños de pantalla. ya que se encarga de extraer el tamaño de la pantalla y devolver el scaffold correspondiente.
- **Page:** Las páginas seran aquellas que tengan un `Scaffold` como su raiz, estas estan ligadas a la carpeta pages aqui se mostraran los widgets que se encargaran de mostrar la UI de la pantalla. las cuales siempre estarn ligadasa una ruta https es decir cada vez que cambies de Page cambiara la ruta de la URL.
- **view:** Las vistas seran widgat que se dibujan y se redibujan de acuerdo a los cambios en el estado de la aplicacion, estas estan ligadas a la carpeta views aqui se mostraran los widgets que se encargaran de mostrar la UI de la pantalla o Page.
- **Shared:** Son los widget que se utilizan en cualquier parte de la aplicacion, se colocaran en la carpeta shared si son utilizados en 3 sitios o mas estableciendo los elementos requeridos y los establecidos por defecto, para mantener un widget padre eficiente y reutilizable.
- **Restricción:** Ningun widget debe devolver un `Scaffold` esto solo esta permitido en la carpeta responsive ya que es el encargado de adaptar la UI a diferentes tamaños de pantalla.

## 6. Mock Data o contenido de texto de los widget
- Todo los contenido de de texto de los widget seran concentrados en la carpeta content organizado en archivos para consumir todos los textos desde una unica carpeta.