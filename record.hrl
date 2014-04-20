% rr("record.hrl").
% People1 = #people{}.
% got #people{name = [], age = undefined}
% People1.
% People2 = People1#people{name="MrTeera", age = 23}.
% เคลียร์ definition ของ record ทั้งหมดใน erl shell, แต่ค่าตัวแปรยังอยู่
% rf().
-record(people, {
          name = "",
          age
         }).
