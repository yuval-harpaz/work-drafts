function amp = aweight(f)

w = 2*pi*f;
s = j*w;
KA = 7.39705e9;

amp = (abs(KA*s.^4./(s+129.4).^2./(s+676.7)./(s+4636)./(s+76655).^2));