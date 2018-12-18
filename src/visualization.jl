function InteractBase.Widget(controller::PushApplier; max_force::Number, max_Δt::Number)
    pushbutton = button("Apply push")
    angleslider = slider(range(Float64(-π), stop=Float64(π), length=51), label="θ")
    magnitudeslider = slider(range(0.0, stop=max_force, length=51), label="mag")
    timeslider = slider(range(0, stop=max_Δt, length=51), label="Δt")

    let controller = controller
        Observables.on(pushbutton) do _
            controller.new_push = true
        end
        Observables.onany(angleslider, magnitudeslider) do θ, magnitude
            frame = controller.jacobian.frame
            s, c = sincos(θ)
            controller.force = FreeVector3D(frame, magnitude * c, magnitude * s, 0.0)
        end
        Observables.on(timeslider) do Δt
            controller.Δt = Δt
        end
    end

    angleslider[] = 0
    magnitudeslider[] = max_force / 2
    timeslider[] = max_Δt

    style(container(
        pad(10px, style(vbox(pushbutton, angleslider, magnitudeslider, timeslider), :fontFamily => "sans-serif", :fontSize => "10pt")),
    ), :width => "350px")
end
