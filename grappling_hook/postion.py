import math


def pendulum_step_simple(
    pivot_x, pivot_y, pivot_z,
    mass_x, mass_y, mass_z,
    vel_x, vel_y, vel_z,
    dt=1/60, g=9.81, damping=0.99
):
    """
    Version 100% scalaire du pendule 3D (Verlet + contrainte de distance).
    Aucune liste, aucun tuple, aucun numpy : chaque coordonnee est une
    variable independante.

    Parametres
    ----------
    pivot_x, pivot_y, pivot_z : float   position du pivot (fixe)
    mass_x, mass_y, mass_z    : float   position actuelle de la masse
    vel_x, vel_y, vel_z       : float   vitesse actuelle de la masse
    dt       : float   pas de temps (s)
    g        : float   acceleration de la pesanteur
    damping  : float   amortissement applique a la vitesse a chaque frame
                        (0.99 = perd 1% par frame, 1.0 = aucun frottement)

    Retour
    ------
    (new_x, new_y, new_z, new_vx, new_vy, new_vz)
    """

    # Longueur du pendule (distance pivot -> masse), a conserver constante
    dx = mass_x - pivot_x
    dy = mass_y - pivot_y
    dz = mass_z - pivot_z
    L = math.sqrt(dx * dx + dy * dy + dz * dz)

    # 1) Deplacement libre : gravite + frottement (sans contrainte)
    free_vx = vel_x * damping
    free_vy = vel_y * damping - g * dt
    free_vz = vel_z * damping

    free_x = mass_x + free_vx * dt
    free_y = mass_y + free_vy * dt
    free_z = mass_z + free_vz * dt

    # 2) Contrainte : on ramene la masse a distance L du pivot
    ddx = free_x - pivot_x
    ddy = free_y - pivot_y
    ddz = free_z - pivot_z
    dist = math.sqrt(ddx * ddx + ddy * ddy + ddz * ddz)

    new_x = pivot_x + ddx / dist * L
    new_y = pivot_y + ddy / dist * L
    new_z = pivot_z + ddz / dist * L

    # 3) La vitesse reelle = deplacement effectif / dt
    new_vx = (new_x - mass_x) / dt
    new_vy = (new_y - mass_y) / dt
    new_vz = (new_z - mass_z) / dt

    return new_x, new_y, new_z, new_vx, new_vy, new_vz


if __name__ == "__main__":
    pivot_x, pivot_y, pivot_z = 0.0, 0.0, 0.0
    mass_x, mass_y, mass_z = 1.0, 0.0, 0.0
    vel_x, vel_y, vel_z = 0.0, 0.0, 2.0

    for frame in range(5):
        mass_x, mass_y, mass_z, vel_x, vel_y, vel_z = pendulum_step_simple(
            pivot_x, pivot_y, pivot_z,
            mass_x, mass_y, mass_z,
            vel_x, vel_y, vel_z,
            dt=1/60, g=9.81, damping=0.99
        )
        print(f"frame {frame}: pos=({mass_x:.4f}, {mass_y:.4f}, {mass_z:.4f})  "
              f"vel=({vel_x:.4f}, {vel_y:.4f}, {vel_z:.4f})")