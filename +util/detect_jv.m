function rl_jv = detect_jv(psi1, psi2, rl)
   vec = angle(psi1) - angle(psi2);
   vec = vec + 2*pi*(vec < -pi) - 2*pi*(vec > pi);
   vec1 = vec(1 : end - 1) > 0;
   vec2 = vec(2 : end) > 0;
   inds = find((vec1 ~= vec2) == 1 & abs(vec(1 : end - 1)) > 0.1);
   rl_jv = 0.5*(rl(inds) + rl(inds + 1));
end