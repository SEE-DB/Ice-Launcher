function status = launchgo(s)

r = s(1);
v = s(2);

if r == r_req
    pos = 1;
else
    pos = 0;
end

if v == v_req
    vel = 1;
else
    vel = 0;
end

if pos == 1 && vel == 1
    status = 1;
else
    status =0;
end