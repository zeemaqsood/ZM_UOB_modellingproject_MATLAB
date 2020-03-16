Avogadro = 6.02214086 * 10^23; % mol ^ -1

Concentration_2D = 80; % um^-2
n = Concentration_2D; 
Area = 1; % um^2

R_2D = nthroot(Area/pi, 2); % um
n = 80;
E2 = @(r) r.^2 .* (1 - r.^2).^(n - 2);
NND = 2 * (n - 1) * R_2D * integral(E2, 0, 1); % um

E3 = @(r) r.^3 .* (1 - r.^3).^(n - 2);
R_3D = NND/(3 * (n - 1) * integral(E3, 0, 1)); % um

Volume = 4/3 * pi * R_3D^3; % um^3
Concentration_3D = n/Volume; % um^-3
Concentration_3D_dm = Concentration_3D * 10^15; % dm^-3
Concentration_3D_mol = Concentration_3D_dm/Avogadro; % mol


rands = zeros(1000, n, 2);
rands(:, :, 1) = R_2D * sqrt(rand(1000, n));
rands(:, :, 2) = 2 * pi *rand(1000, n);

x = rands(1, :, 1) .* sin(rands(1, :, 2));
y = rands(1, :, 1) .* cos(rands(1, :, 2));

plot(x, y, ".", 'color', 'r');
hold on;
plot(0, 0, "x", 'color', 'k');
viscircles([0, 0], R_2D, 'color', 'k');
viscircles([0, 0],  NND, 'color', 'k', 'LineStyle', '--');
plot([0, NND], [0, 0], 'k')
hold off;

