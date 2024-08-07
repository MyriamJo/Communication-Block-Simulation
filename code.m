clc;
close all;
clear all;
t=0:0.1:15;
Input=sin(0.2*pi*t);
L=16;
a=1;
Xs=Input(1:2:end);
delta=(2*a)/L;
Y_pos=delta/2:delta:((delta/2)+((L/2-1)*delta));
Y_neg=-1*Y_pos;
Y=[Y_neg,Y_pos];
Y=sort(Y);
X=-1*a:delta:a;
Xq=ones(1,length(Xs));
for i=1:length(Xs)
    for j=1:length(X)-1
        if(Xs(i)> X(j) && Xs(i)<=X(j+1))
              Xq(i)=Y(j);
        end
    end 
end
encoder=[];
for i=1:length(Xq)
 index=find(Y==Xq(i));
 encoder=[encoder,index-1];  
end
symbols=unique(encoder);
probs=(1/length(encoder))*ones(1,length(symbols));
for i= 1:length(symbols)
    counter = 0;
    for j=1:length(encoder)
        if symbols(i)==encoder(j)
            counter =counter+1;
        end

    end
    probs(i)=probs(i)*counter;
end
[dict,L_DASH] = huffmandict(symbols,probs);
code=huffmanenco(encoder,dict);
decode=huffmandeco(code,dict);
Xr=ones(1,length(decode));
for i=1:length(decode)
    index=decode(i);
    Xr(i)=Y(index+1);
end
plot(t,Input)
xlabel('Time');
title("Transmitted VS Received Signal");
ylabel('Amplitude');
hold on;
plot(t(1:2:end),Xr)
legend('Input Signal','Output Signal');
SQNR=3*L^2;
for i=1:length(dict)
  temp=dict{i,2};
  L_DASH=L_DASH+length(temp)*probs(i);
end
NumCompression=log2(L);
CompressionRatio=NumCompression/L_DASH;
NumEfficiency=0;
for i=1:length(probs)
     temp=probs(i)*-log2(probs(i));
     NumEfficiency=NumEfficiency+temp;
end
Efficiency=NumEfficiency/L_DASH;
