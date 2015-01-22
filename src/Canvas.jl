module Canvas

using Patchwork
using Reactive
using Requires

import Base: writemime

export Elem

# Polymer Setup
const custom_elements = readall(Pkg.dir("Canvas", "assets", "vulcanized.html"))

include("length.jl")
include("util.jl")
include("layout.jl")
include("looks.jl")
include("signals.jl")
include("widgets.jl")
include("render.jl")

# Fallback to Patchwork writemime
writemime(io::IO, m::MIME"text/html", x::Tile) =
    writemime(io, m, Canvas.render(x))

@require IJulia begin
    include("ijulia.jl")
end

@require Blink begin
    # This is still defunct though
    import BlinkDisplay, Graphics

    Blink.windowinit() do w
        Blink.head(w, custom_elements_html)
    end

    Graphics.media(Tile, Graphics.Media.Graphical)
end

@require Gadfly begin
    function convert(::Type{Tile}, p::Gadfly.Plot)
        backend = Compose.Patchable(
                     Compose.default_graphic_width,
                     Compose.default_graphic_height)
        convert(Tile, Compose.draw(backend, p))
    end
end

end